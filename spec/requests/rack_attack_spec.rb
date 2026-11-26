require "spec_helper"

describe "Rack::Attack throttles", type: :request do
  def post_from(ip, path, params = {})
    post path, params: params, headers: { "REMOTE_ADDR" => ip }
  end

  shared_examples "a throttled endpoint" do |path, limit, params|
    it "allows #{limit} POSTs to #{path} per IP, then returns 429" do
      limit.times do
        post_from("1.2.3.4", path, params)
        expect(response).not_to have_http_status(:too_many_requests)
      end

      post_from("1.2.3.4", path, params)
      expect(response).to have_http_status(:too_many_requests)
    end

    it "counts each IP separately" do
      limit.times { post_from("1.2.3.4", path, params) }

      post_from("5.6.7.8", path, params)
      expect(response).not_to have_http_status(:too_many_requests)
    end
  end

  it_behaves_like "a throttled endpoint", "/rulebooks", 5,
                  { access_code: "wrong", rulebook: { rulebook_name: "X", subdomain: "x" } }
  it_behaves_like "a throttled endpoint", "/admin_upgrades", 5, { access_code: "wrong" }
  it_behaves_like "a throttled endpoint", "/users/password", 5, { user: { email: "a@example.com" } }

  # sign_in has a per-email limit (5) below its per-IP limit (10), so vary the email to test the IP limit.
  it_behaves_like "a throttled endpoint", "/users/sign_in", 10, {}

  describe "sign in per email" do
    it "allows 5 attempts for one email across IPs, then returns 429" do
      5.times do |i|
        post_from("203.0.113.#{i}", "/users/sign_in", user: { email: "Robin@Example.com", password: "x" })
        expect(response).not_to have_http_status(:too_many_requests)
      end

      post_from("203.0.113.99", "/users/sign_in", user: { email: "robin@example.com ", password: "x" })
      expect(response).to have_http_status(:too_many_requests)
    end
  end

  describe "behind the ALB" do
    def post_via_alb(client_ip)
      post "/rulebooks", params: { access_code: "wrong", rulebook: { subdomain: "x" } },
                         headers: { "REMOTE_ADDR" => "10.0.1.50", "X-Forwarded-For" => client_ip }
    end

    it "throttles on the client IP from X-Forwarded-For, not the ALB's address" do
      5.times { post_via_alb("198.51.100.1") }

      post_via_alb("198.51.100.2")
      expect(response).not_to have_http_status(:too_many_requests)

      post_via_alb("198.51.100.1")
      expect(response).to have_http_status(:too_many_requests)
    end
  end

  it "does not throttle GET requests to a throttled path" do
    7.times { get "/rulebooks/new", headers: { "REMOTE_ADDR" => "1.2.3.4" } }
    expect(response).not_to have_http_status(:too_many_requests)
  end
end
