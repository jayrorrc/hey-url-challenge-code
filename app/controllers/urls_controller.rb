# frozen_string_literal: true

class UrlsController < ApplicationController
  def index
    @url = Url.new
    @urls = Url.order("created_at DESC").limit(10)
  end

  def create
    lengthHash = Array(1..5).sample
    charset = Array('A'..'Z') + Array('a'..'z') + Array(0..9)
    short_url = Array.new(lengthHash) {charset.sample}.join

    while Url.exists?(short_url: short_url) do
      lengthHash = Array(1..5).sample
      short_url = Array.new(lengthHash) {charset.sample}.join
    end

    @url = Url.new(url_params)
    @url.short_url = short_url

    if not @url.save
      flash[:notice] = @url.errors['original_url'].first
    end

    redirect_back fallback_location: root_path
  end

  def show
    @url = Url.find_by(short_url: params[:url])

    if @url.blank?
      redirect_to not_found_path
      return
    end

    clicks_from_this_month = @url.clicks
      .where("created_at >= ? AND created_at <= ?", Time.now.beginning_of_month, Time.now.end_of_month)

    @daily_clicks = []

    clicks_from_this_month
      .group_by{ |m| m.created_at.beginning_of_day }
      .each { |date, clicks| @daily_clicks.push([date.mday, clicks.length()]) }

    @browsers_clicks = []

    clicks_from_this_month
      .group_by{ |m| m.browser }
      .each { |browser, clicks| @browsers_clicks.push([browser, clicks.length()]) }

    @platform_clicks = []

    clicks_from_this_month
      .group_by{ |m| m.platform }
      .each { |browser, clicks| @platform_clicks.push([browser, clicks.length()]) }
  end

  def visit

    @url = Url.find_by(short_url: params[:url])

    if @url.blank?
      redirect_to not_found_path
      return
    end

    browser = Browser.new(request.user_agent, accept_language: "en-us")

    browserName = browser.name
    browserPlatform = browser.platform.name

    click = Click.new(platform: browserPlatform, browser: browserName, url: @url)

    if click.save
      require "net/http"

      urlString = @url.original_url

      if !urlString.end_with?('/')
          urlString += '/'
      end

      begin
        url = URI.parse(urlString)
        req = Net::HTTP.new(url.host, url.port)
        res = req.request_head(url.path)
      rescue
        redirect_to not_found_path
      else
        if res.code == '200' or res.code == '301'
          redirect_to @url.original_url
        else
          redirect_to not_found_path
        end
      end
    else
      redirect_to not_found_path
    end
  end

  private
    def url_params
      params.require(:url).permit(:original_url)
    end
end
