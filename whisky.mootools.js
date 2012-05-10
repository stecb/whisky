(function() {

  var Whisky, eventSplitter,
    __slice = Array.prototype.slice;

  this.merge = function(obj, args) {
    var key, props, value, _i, _len;
    for (_i = 0, _len = args.length; _i < _len; _i++) {
      props = args[_i];
      for (key in props) {
        value = props[key];
        obj[key] = value;
      }
    }
    return obj;
  };

  this.extend = function() {
    var args, klass;
    klass = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    return merge({
      Extends: klass
    }, args);
  };

  this.implement = function() {
    var args, klass;
    klass = arguments[0], args = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    return merge({
      Implements: klass
    }, args);
  };

  Whisky = this.Whisky = {
    VERSION: '0.1'
  };

  eventSplitter = /^(\S+)\s*(.*)$/;

  Whisky.Mixins = new Class({
    getUrl: function(action, obj) {
      return this.urls[action] && this.urls[action].substitute(obj);
    },
    setEvents: function() {
      var evt, k, m, match, sel;
      for (k in this.events) {
        m = this.events[k];
        m = (typeof m === "function" ? m.bind(this) : this[m].bind(this));
        match = k.match(eventSplitter);
        evt = match[1];
        sel = match[2];
        if (sel === "") {
          this.element.addEvent(evt, m);
        } else {
          this.element.addEvent("" + evt + ":relay(" + sel + ")", m);
        }
      }
      return this;
    }
  });

  Whisky.View = new Class(implement([Events, Options, Whisky.Mixins], {
    options: {},
    tagName: 'div',
    urls: {},
    initialize: function(o) {
      this.setOptions(o);
      this.setElement();
      this.setEvents();
      return this;
    },
    setElement: function() {
      if (!(this.element != null)) this.element = new Element(this.tagName);
      return this;
    },
    toElement: function() {
      return this.element;
    },
    render: function() {
      return this;
    }
  }));

  Whisky.App = new Class(implement([Events, Options, Whisky.Mixins], {
    options: {},
    urls: {},
    initialize: function(o) {
      this.setOptions(o);
      this.setEvents();
      this.loadTemplates();
      return this;
    },
    loadTemplates: function() {
      var i, l, template,
        _this = this;
      this.totTemplates = this.options.templates ? this.options.templates.length : 0;
      this.templates = {};
      if (this.totTemplates > 0) {
        i = 0;
        l = this.options.templates.length;
        while (i < l) {
          template = this.options.templates[i];
          (function(t) {
            return Fitmo.getTemplate(t, function(template) {
              _this.totTemplates--;
              _this.templates[t] = template;
              return _this.checkAllLoaded();
            });
          })(template);
          i++;
        }
        return this;
      }
    },
    templatesReady: function() {
      return this;
    },
    checkAllLoaded: function() {
      if (this.totTemplates === 0) return this.templatesReady();
    }
  }));

}).call(this);