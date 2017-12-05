class Tide
  route 'stations' do |r|
    r.is do
      @page = (params[:page] || 1).to_i
      @stations = DataSet.exclude(datum: nil).reverse(:index).paginate(@page, 100)

      r.get do
        view 'stations/index'
      end
    end

    r.on 'new' do
      @ref_stations = ReferenceStationView.order(:name)

      r.get do
        @station = DataSet.new
        view 'stations/new'
      end

      r.post do
        @station = DataSet.new(params[:stations])
        if @station.valid?
          @station.save
          flash[:success] = 'Station has been saved successfully!.'
          if @station.is_subordinate?
            r.redirect "/stations/#{@station.index}/edit/offset"
          end
          if @station.is_reference?
            r.redirect "/stations/#{@station.index}/edit/constituents"
          end
        else
          flash.now[:error] = @station.errors.full_messages.join(', ')
          view 'stations/new'
        end
      end
    end

    r.on 'edit' do
      @station = DataSet[params[:index]]
      @ref_stations = ReferenceStationView.order(:name)
      r.is do
        r.post do
          type = params[:type]
          @station.set(params[:stations])
          if params[:constants]
            cons_params = params[:constants].delete_if do |x|
              x[:amp].empty? && x[:phase].empty?
            end
          end
          @station.set(constants_attributes: cons_params)
          if @station.valid?
            flash[:success] = 'Station has been updated successfully!.'
            @station.save_changes
            r.redirect "/stations/#{@station.index}/edit/#{type}"
          else
            flash.now[:error] = @station.errors.full_messages.join(', ')
            view "/stations/edit_#{type}"
          end
        end
      end
    end

    r.on Integer do |index|
      @station = DataSet[index]
      @ref_stations = ReferenceStationView.order(:name)

      r.on 'show' do
        r.is do
          r.get do
            view 'stations/show'
          end
        end
      end

      r.on 'test' do
        view 'stations/test'
      end

      r.on 'edit' do
        r.is 'general' do
          r.get do
            view 'stations/edit_general'
          end
        end

        r.on 'constituents' do

          r.redirect 'offset' if @station.is_subordinate?

          r.is do
            r.get do
              view 'stations/edit_constituents'
            end
          end

          r.is 'new' do
            view 'stations/constituents/new'
          end

        end

        r.is 'offset' do
          r.redirect 'constituents' if @station.is_reference?

          r.get do
            view 'stations/edit_offset'
          end
        end

        r.is 'verbiage' do
          r.get do
            view 'stations/edit_verbiage'
          end
        end
      end
    end

    r.on 'destroy' do
    end
  end
end

# if params[:constants]
#   cons_params = params[:constants].values.delete_if do |x|
#     x[:amp].empty? && x[:phase].empty?
#   end
#   @station.constants_attributes = cons_params
# end
#
#   # r.post String do |redirect_to|
#   #   cons_params = params[:constants].values.delete_if do |x|
#   #     x[:amp].empty? && x[:phase].empty?
#   #   end
#   #   @station.set(params[:stations])
#   #   @station.set(constants_attributes: cons_params)
#   #   if @station.valid?
#   #     flash[:success] = 'Station has been updated successfully!.'
#   #     @station.save_changes
#   #     r.redirect
#   #   else
#   #     flash.now[:error] = @station.errors.full_messages.join(', ')
#   #     view 'stations/edit'
#   #   end
#   # end
# end
