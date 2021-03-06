# UnobtrusiveSortHelper

This is a plugin version of Stuart Rackham's most excellent SortHelper helper. The link_to_remote ajax calls have been removed in favor of unobtrusive javascript using lowpro.js.

## Features

- Consecutive clicks toggle the column's sort order.
- Sort state is maintained by a session hash entry.
- Icon image identifies sort column and state.
- Typically used in conjunction with will_paginate plugin

## Installation

In Rails 3, you just install the plugin and run the generator

    $ rails plugin install git://github.com/oozou/ujs_sort_helper.git
    $ rails generate ujs_sort_helper:install

## Usage

### Controller:

    def list
      sort_init 'last_name'
      sort_update
      @items = Contact.find_all nil, sort_clause
    end

### Controller (using will\_paginate)

    def list
      sort_init 'last_name'
      sort_update
    
      options = {:page => params[:page], :include => :addresses, :order => sort_clause
    
      @contacts = Contact.paginate(options)
    end

### Layout (app/views/layouts/application.html.erb):

    <%= stylesheet_link_tag "ujs_sort_helper"%> 

styles for nifty sort arrow images

    <%= javascript_include_tag :defaults%> 

as long as prototype.js is included before lowpro and ujs_sort_helper

If you're not using jQuery, reference Dan Webb's lowpro and the Prototype version
of the ujs_sort_helper:

    <%= javascript_include_tag "lowpro"%> 

you SHOULD already have this ;-)

    <%= javascript_include_tag "ujs_sort_helper", :plugin => "ujs_sort_helper"%> 

If you're using jQuery, simply include the jQuery version (assuming you already
have jQuery and livequery installed)

    <%= javascript_include_tag "ujs_sort_helper.jquery.js", :plugin => "ujs_sort_helper"%> 

### View (table header in index.rhtml):

    <thead>
      <tr>
        <%= sort_header_tag('id', :title => 'Sort by contact ID') %>
        <%= sort_header_tag('last_name', :caption => 'Name') %>
        <%= sort_header_tag('phone') %>
        <%= sort_header_tag('address', :width => 200) %>
      </tr>
    </thead>

- The ascending and descending sort icon images are sort_asc.png and sort_desc.png and reside in the application's images directory.
- Introduces instance variables: @sort_name, @sort_default.
- Introduces params :sort_key and :sort_order.

---------------------------------------

Copyright (c) 2005 Stuart Rackham, (c) 2008 Wynn Netherland released under the MIT license
