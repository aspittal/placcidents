class AccidentsController < ApplicationController
  # GET /accidents
  # GET /accidents.json
  def index
    @accidents = Accident.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @accidents }
    end
  end

  # GET /accidents/1
  # GET /accidents/1.json
  def show
    @accident = Accident.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @accident }
    end
  end

  # GET /accidents/new
  # GET /accidents/new.json
  def new
    @accident = Accident.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @accident }
    end
  end

  # GET /accidents/1/edit
  def edit
    @accident = Accident.find(params[:id])
  end

  # POST /accidents
  # POST /accidents.json
  def create
    @accident = Accident.new(params[:accident])

    respond_to do |format|
      if @accident.save
        format.html { redirect_to @accident, notice: 'Accident was successfully created.' }
        format.json { render json: @accident, status: :created, location: @accident }
      else
        format.html { render action: "new" }
        format.json { render json: @accident.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /accidents/1
  # PUT /accidents/1.json
  def update
    @accident = Accident.find(params[:id])

    respond_to do |format|
      if @accident.update_attributes(params[:accident])
        format.html { redirect_to @accident, notice: 'Accident was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @accident.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accidents/1
  # DELETE /accidents/1.json
  def destroy
    @accident = Accident.find(params[:id])
    @accident.destroy

    respond_to do |format|
      format.html { redirect_to accidents_url }
      format.json { head :no_content }
    end
  end
end
