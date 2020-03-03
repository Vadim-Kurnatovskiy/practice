class ClientsController
   def create
    @client = @carwash.clients.new(client_params)
    
    if current_user.is_owner_of?(@carwash) || current_user.is_manager?
      @client.bonus = params[:client][:bonus] if params[:client][:bonus].present?
      @client.status = params[:client][:status]
    end

    if @client.save
      redirect_to @client, notice: 'Клиент успешно добавлен' }
    else
      render action: 'new'
    end
  end

  def update
    if current_user.is_owner_of?(@carwash) || current_user.is_manager?
      @client.bonus = params[:client][:bonus] if params[:client][:bonus].present?
      @client.status = params[:client][:status]
    end

    if @client.update_attributes(client_params)
      redirect_to @client, notice: 'Данные клиента сохранены'
    else
      render action: 'edit'
    end
  end
end