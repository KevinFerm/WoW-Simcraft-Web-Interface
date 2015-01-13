class CharactersController < ApplicationController
  before_action :set_character, only: [:show, :edit, :update, :destroy]
  #include Wowchar

  # GET /characters
  # GET /characters.json
  def index
    @characters = Character.all
  end

  # GET /characters/1
  # GET /characters/1.json
  def show
    #Gets character data from the model
    @character = Character.getchar(params[:region], params[:realm], params[:name])
      #If there's no char data, take the params and create a new one
     if(@character.nil?)
       Character.createChar(params[:region],params[:realm],params[:name])
     else
       #Set the title
       gon.character = @character.to_json
       @title = params[:name].titleize + " - "+ params[:realm].titleize + " - " + params[:region].upcase
       gon.charstuff = Character.normalize_character(params[:region])+','+Character.normalize_realm(params[:realm])+','+Character.normalize_character(params[:name])
       #Several variables used in the view
       @row1 = ['head', 'neck', 'shoulder','back', 'chest','wrist','mainHand','offHand']
       @row2 = ['hands','waist','legs','feet','finger1','finger2','trinket1','trinket2']
       @stats = ['str',
                 'agi',
                 'int',
                 'sta',
                 'speedRating',
                 'speedRatingBonus',
                 'crit',
                 'haste',
                 'hasteRating',
                 'mastery',
                 'spr',
                 'bonusArmor',
                 'multistrike',
                 'versatility',
                 'avoidanceRating',
                 'spellPower',
                 'spellCrit',
                 'rangedAttackPower',
                 'attackPower',
                 'rangedDmgMin',
                 'rangedDmgMax',
                 'rangedSpeed',
                 'rangedDps']
     end
  end

  # GET /characters/new
  def new
    @character = Character.new
    render :action => "new"
  end

  # GET /characters/1/edit
  def edit
  end

  # POST /characters
  # POST /characters.json
  def create
    #Checks if character exists, if it doesn't, then create another one
    @character = Character.getchar(character_params[:region], character_params[:realm], character_params[:name])
    @character ||= Character.createChar(character_params[:region],character_params[:realm],character_params[:name])
      #if character exists when youve run the post request i.e, it's been created or already exists, redirect to the show view
      if @character != false && @character != "Character not found" then
        redirect_to char_path(@character['region'],@character['realm'],@character['name']), notice: 'Character was successfully created.'
        #Else, redirect back to the create view
      else
        flash[:notice] = "Character not found!"
        return new
        # format.html { render :new }
        # format.json { render json: @character.errors, status: :unprocessable_entity }
      end
  end

  # PATCH/PUT /characters/1
  # PATCH/PUT /characters/1.json
  def update
    respond_to do |format|
      if @character.update(character_params)
        format.html { redirect_to @character, notice: 'Character was successfully updated.' }
        format.json { render :show, status: :ok, location: @character }
      else
        format.html { render :edit }
        format.json { render json: @character.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /characters/1
  # DELETE /characters/1.json
  def destroy
    @character.destroy
    respond_to do |format|
      format.html { redirect_to characters_url, notice: 'Character was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_character
      @character = Character.where(region: params[:region], name: params[:name], realm: params[:realm]).take
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def character_params
      params.require(:character).permit(:name, :region, :realm)
    end
end
