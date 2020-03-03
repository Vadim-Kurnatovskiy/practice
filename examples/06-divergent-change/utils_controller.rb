class UtilsController
   def search
    redirect_to adv_search_url and return if params[:q].blank?
    @books = case params[:field]
      when 'author' then Book.found_by_author(params[:q])
      when 'title' then Book.found_by_title(params[:q])
      when 'number' then Book.found_by_number(params[:q])
      else Book.found(params[:q])
    end

    respond_to do |format|
      format.html { render 'shared/_books' }
      format.csv { render 'shared/_books' }
      format.xls { export_books_to_xls(@books) }
    end
  end
end