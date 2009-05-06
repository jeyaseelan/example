# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def set_focus_to_id(id)
    javascript_tag("Event.observe(window, 'load', $('#{id}').focus());")
  end
  
  def date_format(date)
    date=date.to_date
    return date.strftime("%d-%m-%Y")
  end
  
end
