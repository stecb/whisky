Whisky = @Whisky = 
  VERSION : '0.2' # Current version of the fw.
  
eventSplitter = /^(\S+)\s*(.*)$/; #from https://github.com/documentcloud/backbone/blob/master/backbone.js#L948  

# View object, holds a view, bound to an element, always!
class View
  #default options
  options : {}
  # the name of the view's main tag
  tagName : 'div'
  # to override, like 'action1' : '/some/url/{id}/{otherParam}' and @getUrl('action1',{id : 123, otherParam : "asd"}) => "/some/url/123/asd"
  urls : {}
  
  #return the proper substituted url
  getUrl : (action, obj) ->
    # @urls[action] and @urls[action].substitute obj
    
  #set defined events on the class who inherits
  setEvents : ->
    for k of @events
      m = @events[k]
      m = (if typeof m is "function" then $.proxy m, @ else $.proxy @[m], @)
      match = k.match eventSplitter
      evt = match[1]
      sel = match[2]
      if sel is ""
        @element.bind evt, m
      else
        @element.delegate "#{sel}", "#{evt}", m
    @
  
  #init method (on new)
  constructor : (o) -> 
    $.extend @options, o
    @setElement()
    @setEvents()
    @
    
  #set the default element, if no element is defined, but don't put in the DOM (render will do it)
  setElement : ->
    @element = $(@tagName) if not @element?
    @
  
  #return the element when toElement is called  
  toElement : -> @element
  
  #to be overridden
  render : -> @

Whisky.View = View

null