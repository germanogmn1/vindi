module Vindi
  class Charge
    class Refund < Base
      def self.create(params = {})
        charge_id = params[:charge_id]
        return false unless charge_id

        resp = Request.new(:post, "charges/#{charge_id}/refund", params).perform
        parse(resp)
      end
    end
  end
end
