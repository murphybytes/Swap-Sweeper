module ApplicationHelper
###############################
# standard date display for
# application
##############################
def format_date( dt )
  dt.strftime( "%B %e, %Y" )
end

############################
# standard date time display
################################
def format_date_time( dt )
  dt.strftime( "%B %e, %Y %I:%M%p" )
end



end
