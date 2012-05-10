(function() {
  
  var View, Whisky, eventSplitter;

  Whisky = this.Whisky = {
    VERSION: '0.2'
  };

  eventSplitter = /^(\S+)\s*(.*)$/;

  View = (function() {

    View.name = 'View';

    View.prototype.options = {};

    View.prototype.tagName = 'div';

    View.prototype.urls = {};

    View.prototype.getUrl = function(action, obj) {};

    View.prototype.setEvents = function() {
      var evt, k, m, match, sel;
      for (k in this.events) {
        m = this.events[k];
        m = (typeof m === "function" ? $.proxy(m, this) : $.proxy(this[m], this));
        match = k.match(eventSplitter);
        evt = match[1];
        sel = match[2];
        if (sel === "") {
          this.element.bind(evt, m);
        } else {
          this.element.delegate("" + sel, "" + evt, m);
        }
      }
      return this;
    };

    function View(o) {
      $.extend(this.options, o);
      this.setElement();
      this.setEvents();
      this;

    }

    View.prototype.setElement = function() {
      if (!(this.element != null)) {
        this.element = $(this.tagName);
      }
      return this;
    };

    View.prototype.toElement = function() {
      return this.element;
    };

    View.prototype.render = function() {
      return this;
    };

    return View;

  })();

  Whisky.View = View;

}).call(this);