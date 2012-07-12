function S4() {
   return (((1+Math.random())*0x10000)|0).toString(16).substring(1);
};

function guid() {
   return (S4()+S4()+"-"+S4()+"-"+S4()+"-"+S4()+"-"+S4()+S4()+S4());
};

var Store = function(name) {
  console.log("Store function called", name);	
  this.name = name;
  var store = localStorage.getItem(this.name);
  this.data = (store && JSON.parse(store)) || {};
  console.log(this.data);

};

_.extend(Store.prototype, {

  save: function() {
	console.log("store.save called");
	localStorage.setItem(this.name, JSON.stringify(this.data));
  },
  
  create: function(model) {
	console.log("store.create called");
    if (!model.id) model.id = model.attributes.id = guid();
	this.data[model.id] = model;
	this.save();
	return model;
  },	
  
  update: function(model) {
    console.log("store.update called");
    this.data[model.id] = model;
    this.save();
    return model;
  },  
  
  find: function(model) {
    console.log("store.find called");
    return this.data[model.id];
  },  
  
  findAll: function() {
    console.log("store.findAll called");
    return _.values(this.data);
  },

  destroy: function(model) {
    console.log("store.destroy called");
    delete this.data[model.id];
    this.save();
    return model;
  }
});

Backbone.sync = function(method, model, options) {
  console.log("Backbone.sync::");  
  var resp;
  var store = model.localStorage || model.collection.localStorage;
  switch (method) {
    case "read":    resp = model.id ? store.find(model) : store.findAll(); break;
    case "create":  resp = store.create(model);                            break;
    case "update":  resp = store.update(model);                            break;
    case "delete":  resp = store.destroy(model);                           break;
  }  
  if (resp) {
    options.success(resp);
  } else {
    options.error("Record not found");
  }  
};  
  