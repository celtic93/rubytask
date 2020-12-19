class SearchResultsController < ApplicationController
  def index
    @search_results = Task.search_tasks(params[:query])
  end
end
