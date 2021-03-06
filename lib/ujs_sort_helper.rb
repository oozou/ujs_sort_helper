# Helpers to sort tables using clickable column headers.
#
# Author:  Stuart Rackham <srackham@methods.co.nz>, March 2005.
# Modified by: Wynn Netherland <wynn@squeejee.com>, February 2008 to use UJS
# License: This source code is released under the MIT license.
#
# - Consecutive clicks toggle the column's sort order.
# - Sort state is maintained by a session hash entry.
# - Icon image identifies sort column and state.
# - Typically used in conjunction with the Pagination module.
#
# Example code snippets:
#
# Controller:
#
#   helper :sort
#   include SortHelper
# 
#   def list
#     sort_init 'last_name'
#     sort_update
#     @items = Contact.find_all nil, sort_clause
#   end
# 
# Controller (using Pagination module):
#
#   helper :sort
#   include SortHelper
# 
#   def list
#     sort_init 'last_name'
#     sort_update
#     @contact_pages, @items = paginate :contacts,
#       :order_by => sort_clause,
#       :per_page => 10
#   end
# 
# View (table header in list.rhtml):
# 
#   <thead>
#     <tr>
#       <%= sort_header_tag('id', :title => 'Sort by contact ID') %>
#       <%= sort_header_tag('last_name', :caption => 'Name') %>
#       <%= sort_header_tag('phone') %>
#       <%= sort_header_tag('address', :width => 200) %>
#     </tr>
#   </thead>
#
# - The ascending and descending sort icon images are sort_asc.png and
#   sort_desc.png and reside in the application's images directory.
# - Introduces instance variables: @sort_name, @sort_default.
# - Introduces params :sort_key and :sort_order.
#
module UjsSortHelper

  # Initializes the default sort column (default_key) and sort order
  # (default_order).
  #
  # - default_key is a column attribute name.
  # - default_order is 'asc' or 'desc'.
  # - name is the name of the session hash entry that stores the sort state,
  #   defaults to '<controller_name>_sort'.
  #
  def sort_init(default_key, default_order='asc', name=nil)
    @sort_name = name || params[:controller] + params[:action] + '_sort'
    @sort_default = {:key => default_key, :order => default_order}
  end

  # Updates the sort state. Call this in the controller prior to calling
  # sort_clause.
  #
  def sort_update()
    if params[:sort_key]
      sort = {:key => params[:sort_key], :order => params[:sort_order]}
    elsif session[@sort_name]
      sort = session[@sort_name]   # Previous sort.
    else
      sort = @sort_default
    end
    session[@sort_name] = sort
  end

  # Returns an SQL sort clause corresponding to the current sort state.
  # Use this to sort the controller's table items collection.
  #
  def sort_clause()
    session[@sort_name][:key] + ' ' + session[@sort_name][:order]
  end

  # Returns a link which sorts by the named column.
  #
  # - column is the name of an attribute in the sorted record collection.
  # - The optional caption explicitly specifies the displayed link text.
  # - A sort icon image is positioned to the right of the sort link.
  #
  def sort_link(column, caption=nil, initial_order="asc")
    key = session[@sort_name][:key].to_sym
    order = sort_order(column, initial_order)
    caption = column.to_s.titleize unless caption

    url = { :sort_key => column, :sort_order => sort_order(column, initial_order), :filter => params[:filter]}
    url.merge!({:q => params[:q]}) unless params[:q].nil?

    link_to(caption, url, :class => "sort_link #{sort_order(column, initial_order) if key == column}")
  end

  # Returns a table header <th> tag with a sort link for the named column
  # attribute.
  #
  # Options:
  #   :caption     The displayed link name (defaults to titleized column name).
  #   :title       The tag's 'title' attribute (defaults to 'Sort by :caption').
  #
  # Other options hash entries generate additional table header tag attributes.
  #
  # Example:
  #
  #   <%= sort_header_tag('id', :title => 'Sort by contact ID', :width => 40) %>
  #
  # Renders:
  #
  #   <th title="Sort by contact ID" width="40">
  #     <a href="/contact/list?sort_order=desc&amp;sort_key=id">Id</a>
  #   </th>
  #
  def sort_header_tag(column, options = {})    
    options[:initial_order].nil? ? initial_order = "asc" : initial_order = options[:initial_order]
    key = session[@sort_name][:key].to_sym
    order = sort_order(column, initial_order)
    caption = options.delete(:caption) || column.to_s.titleize

    url = { :sort_key => column, :sort_order => order, :filter => params[:filter]}
    url.merge!({:q => params[:q]}) unless params[:q].nil?

    content_tag('th', link_to(caption, url, options.except(:initial_order)), :class => "sort_link #{order if key == column}")
  end

  private

  def sort_icon(column)
    if session[@sort_name][:key] == column
      "sort#{session[@sort_name][:order].downcase}"
    end
  end

  def sort_order(column, initial_order='asc')
    if session[@sort_name][:key].to_sym == column
      session[@sort_name][:order].downcase == 'asc' ? 'desc' : 'asc'
    else
      initial_order
    end
  end

  # Return n non-breaking spaces.
  def nbsp(n)
    '&nbsp;' * n
  end
end
