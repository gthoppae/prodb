## $Id: sorting_helper.rb,v 1.2 2005/07/31 15:24:24 sbooth Exp $
module SortingHelper

  class Sorter

    def initialize(controller, columns, sort, order = 'ASC', default_sort = 'id', default_order = 'ASC')
      sort            = default_sort unless columns.include? sort
      order           = default_order unless ['ASC', 'DESC'].include? order

      @controller     = controller
      @columns        = columns
      @sort           = sort
      @order          = order
      @default_sort   = default_sort
      @default_order  = default_order
    end

    def to_sql
      @sort + ' ' + @order
    end

    def to_link(column, params={})
      column = @default_sort unless @columns.include?(column)

      if column == @sort
        order = ('ASC' == @order ? 'DESC' : 'ASC')
      else
        order = @default_order
      end

      { :params => { 'sort' => column, 'order' => order }.merge(params) }
    end

  end

end