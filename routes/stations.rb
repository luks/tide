class Tide
  route 'stations' do |r|
    r.is do
      @page = (params[:page] || 1).to_i
      @stations = DataSet.reverse(:index).paginate(@page, 100)
      r.get do
        view 'stations/index'
      end
    end

    r.on 'new' do
      @station = DataSet.new
      r.is do
        r.get do
          view 'stations/steps/_general'
        end

        r.post do
          @station = DataSet.new(params[:stations])
          if params[:constants]
            cons_params = params[:constants].values.delete_if do |x|
              x[:amp].empty? && x[:phase].empty?
            end
            @station.constants_attributes = cons_params
          end
          if @station.valid?
            @station.save
            flash[:success] = 'Station has been saved successfully!.'
            r.redirect "/stations/#{@station.index}/edit"
          else
            flash.now[:error] = @station.errors.full_messages.join(', ')
            view 'stations/steps/_general'
          end
        end
      end

      r.on 'general' do
        r.is do
          r.get do
            view 'stations/steps/_general'
          end
          r.post do
            @station = DataSet.new(params[:stations])
            if @station.is_valid?
              @station.save
              flash[:success] = 'Station has been saved successfully!.'
              r.redirect "/stations/#{@station.index}/constituents"
            end
          end
        end
      end
    end

    r.on Integer do |index|
      @station = DataSet[index]
      r.on 'general/edit' do
        r.is do
          r.get do
            view 'stations/steps/_general'
          end
        end
      end

      r.on 'constituents/edit' do
        r.is do
          r.get do
            view 'stations/steps/_constituents'
          end
        end
      end

      r.on 'verbiage/edit' do
        r.is do
          r.get do
            view 'stations/steps/_verbiage'
          end
        end
      end

      r.on 'offset/edit' do
        r.is do
          r.get do
            view 'stations/steps/_offset'
          end
        end
      end

      r.on 'show' do
        r.is do
          # GET /stations/1111/show
          r.get do
            view 'stations/show'
          end
        end
      end

      r.on 'edit' do
        @action = "/stations/#{index}/edit"
        # GET /stations/111/edit
        r.is do
          r.get do
            view 'stations/edit'
          end

          # PUT /stations/111/edit
          r.post do
            cons_params = params[:constants].values.delete_if do |x|
              x[:amp].empty? && x[:phase].empty?
            end
            @station.set(params[:stations])
            @station.set(constants_attributes: cons_params)
            if @station.valid?
              flash[:success] = 'Station has been updated successfully!.'
              @station.save_changes
              r.redirect
            else
              flash.now[:error] = @station.errors.full_messages.join(', ')
              view 'stations/edit'
            end
          end
        end
      end

      r.on 'delete' do
      end
    end
  end
end
