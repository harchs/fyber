class OffersController < ApplicationController
  def index
    Offer.all(params[:offer])
  end
end