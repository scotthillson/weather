class LogsController < ApplicationController

  before_action :set_log, only: [:show, :edit, :update, :destroy]

  def index
    @logs = Log.all.order(:created_at).reverse
  end

  def show
  end

  def new
    @log = Log.new
  end

  def edit
  end

  def create
    @log = Log.new(log_params)
    respond_to do |format|
      if @log.save
        format.html { redirect_to @log, notice: 'Log was successfully created.' }
        format.json { render action: 'show', status: :created, location: @log }
      else
        format.html { render action: 'new' }
        format.json { render json: @log.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @log.update(log_params)
        format.html { redirect_to @log, notice: 'Log was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @log.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @log.destroy
    respond_to do |format|
      format.html { redirect_to logs_url }
      format.json { head :no_content }
    end
  end

  private

  def set_log
    @log = Log.find(params[:id])
  end

  def log_params
    params.require(:log).permit(:action, :note, :run)
  end

end
