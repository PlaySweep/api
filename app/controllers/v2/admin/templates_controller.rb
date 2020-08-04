class V2::Admin::TemplatesController < BasicAuthenticationController
  respond_to :json

  def index
    @templates = Template.active
    @templates = Template.filtered(params[:owner_id]) if params[:owner_id]
    respond_with @templates
  end

  def build
    template = Template.find(params[:template_id])
    owner = Owner.find(template.owner_id)
    slate_name = params[:name]
    if params[:contest_id]
      contest = Contest.find(params[:contest_id])
    else
      contest = Contest.find_by(name: "#{owner.abbreviation} Contest")
    end
    slate = Slate.create(name: slate_name, owner_id: template.owner_id, start_time: params[:start_time], contest_id: contest.id)
    product = Product.find_by(default: true)
    slate.prizes.create(product_id: product.id, sku_id: product.skus.first.id)
    if slate_name.include?("@")
      away_abbreviation = slate_name.split("@").map(&:strip)[0]
      home_abbreviation = slate_name.split("@").map(&:strip)[1]
      away = Owner.by_name(away_abbreviation)
      home = Owner.by_name(home_abbreviation)
      slate.participants.create(owner_id: away.id, field: "away")
      slate.participants.create(owner_id: home.id, field: "home")
    else
      owner = Owner.find_by(name: slate_name)
      slate.participants.create(owner_id: owner.id, field: params[:field])
    end
    template.items.ordered.each do |item|
      event = slate.events.create(order: item.order, description: item.description, category: item.category)
      item.options.ordered.each do |option|
        event.selections.create(order: option.order, description: option.description, category: option.category)
      end
    end
    render json: { status: 200 } if slate.valid?
  end

  private

  def template_params
    params.require(:template).permit(:name, :owner_id, :active)
  end
end