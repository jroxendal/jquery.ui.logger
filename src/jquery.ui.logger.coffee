c = console ? {log : $.noop}

$.widget "spyder.logger",  
  options : 
    level : 0
    levels :
      DEBUG : 10
      INFO : 20
      WARN : 30
      ERROR : 40
      CRITICAL : 50
  _init : ->
    @element
    .addClass("ui-logger")
    .append("<table>")
    
    inputs = for level, val of @options.levels
      """<label for='chk_#{level}'>#{level.toLowerCase()}</label>
         <input type='checkbox' id='chk_#{level}' checked='checked' data-level='#{level}'>"""
    $('<div class="logger-controls">')
      .html(inputs.join(""))
      .appendTo @element
      .change (evt) =>
        lv = @options.levels[$(evt.target).data("level")]
        display = if $(evt.target).is(":checked") then "table-row" else "none"
        @element.find(".logger-level-" + lv).css("display", display)
      
    
    @item_tmpl = _.template '''
      <tr class="logger-item logger-level-<%= level %>">
        
        <td class="logger-header"><%= this.getLevelLabel(level).toLowerCase() %></td>
        <td class="logger-body closed">
          <%= msg %>
          
          <span class="<%= typeof(data) == 'undefined' ? 'no_data' : '' %> ui-icon ui-icon-circlesmall-plus"></span>
          <pre class="logger-data"><%= JSON.stringify(data, null, 4) %></pre>
        </td>
      </div>
    '''
    
    $(".ui-icon-circlesmall-plus").live "click", ->
      $(this).parent().toggleClass("closed")
       
    
    # for label, val of @options.levels
      # this[label.toLowerCase()] = (args...) =>
        # @log.apply(this, args)
      
  
  getLevelLabel : (lvl) ->
    lbl = (label for label, val of @options.levels when val == lvl)[0]
    lbl or "INFO"
  
  tmpl : (data) ->
    $ @item_tmpl(data)
  
  log : (level, msg, data) ->
    if level <  @options.level
      return @element
    data = if data not instanceof Element then data else $("<div>").append(data).html()
    @tmpl({msg : msg, level : level, data : data}).appendTo @element
    return @element
  
  debug : (args...) -> 
    @log [@options.levels.DEBUG].concat(args)...

  info : (args...) ->
    @log [@options.levels.INFO].concat(args)...
  
  warn : (args...) -> 
    @log [@options.levels.WARN].concat(args)...
    
  error : (args...) -> 
    @log [@options.levels.ERROR].concat(args)...
  critical : (args...) -> 
    @log [@options.levels.CRITICAL].concat(args)...
    
  

#$ ->
#  window.logger = $("#logger")
#  .logger(
#  # level : 0
#  )
#  .logger("debug","another message")
#  .logger("info", "this is a message", data : 133)
#  .logger("warn", "this is a message", data : 133)
#  .logger("error","error message", data : 133)
#  .logger("critical","error message", data : 133)
  