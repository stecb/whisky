###
  helper to use mootools Class with coffee
###

@merge     = (obj,   args)    ->  (obj[key] = value for key, value of props for props in args); obj
@extend    = (klass, args...) ->  merge {    Extends: klass }, args
@implement = (klass, args...) ->  merge { Implements: klass }, args



Whisky = @Whisky = 
  VERSION : '0.1' # Current version of the fw.
  
eventSplitter = /^(\S+)\s*(.*)$/; #from https://github.com/documentcloud/backbone/blob/master/backbone.js#L948  

# ---

#to be used both on View and Page, see urls inside View or Page
Whisky.Mixins = new Class
  #return the proper substituted url
  getUrl : (action, obj) ->
    @urls[action] and @urls[action].substitute obj
    
  #set defined events on the class who inherits
  setEvents : ->
    for k of @events
      m = @events[k]
      m = (if typeof m is "function" then m.bind @ else @[m].bind @)
      match = k.match eventSplitter
      evt = match[1]
      sel = match[2]
      if sel is ""
        @element.addEvent evt, m
      else
        @element.addEvent "#{evt}:relay(#{sel})", m
    @

# ---

# View object, holds a view, bound to an element, always!
Whisky.View = new Class implement [Events, Options, Whisky.Mixins],
  #default options
  options : {}
  # the name of the view's main tag
  tagName : 'div'
  # to override, like 'action1' : '/some/url/{id}/{otherParam}' and @getUrl('action1',{id : 123, otherParam : "asd"}) => "/some/url/123/asd"
  urls : {}
  
  #init method (on new)
  initialize : (o) -> 
    @setOptions o
    @setElement()
    @setEvents()
    @
    
  #set the default element, if no element is defined, but don't put in the DOM (render will do it)
  setElement : ->
    @element = new Element @tagName if not @element?
    @
  
  #return the element when toElement is called  
  toElement : -> @element
  
  #to be overridden
  render : -> @

# ---

# PageApp  
Whisky.App = new Class implement [Events, Options, Whisky.Mixins],
  #default options
  options : {}
  # to override, like 'action1' : '/some/url/{id}/{otherParam}' and this.getUrl('action1',{id : 123, otherParam : "asd"}) => "/some/url/123/asd"
  urls : {}
  
  #init method
  initialize : (o) ->
    @setOptions o
    @setEvents()
    @loadTemplates()
    @
    
  #load templates
  loadTemplates : ->
    @totTemplates = if @options.templates then @options.templates.length else 0
    @templates = {}
    
    if @totTemplates > 0
      i = 0
      l = @options.templates.length

      while i < l
        template = @options.templates[i]
        ((t) =>
          Fitmo.getTemplate t, (template) =>
            @totTemplates--
            @templates[t] = template
            @checkAllLoaded()
        ) template
        i++
        
      @
  
  #to be overridden
  templatesReady : -> @
  
  #check wether all templates are loaded
  checkAllLoaded: ->
    @templatesReady() if @totTemplates is 0
    
null