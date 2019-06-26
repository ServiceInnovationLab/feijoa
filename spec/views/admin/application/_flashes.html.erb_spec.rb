require "rails_helper"

RSpec.describe "rendering flash messages in admin/application/flashes" do
  it "renders a raw html string of the alert and notice values" do
    flash = {
      :alert=>"Your session expired. Please sign in again to continue.",
      :notice=>"A notice",
      :system=>"this is not rendered"
    }

    render "admin/application/flashes", :flash => flash

    expect(rendered).to include("Your session expired. Please sign in again to continue.")
    expect(rendered).to include("A notice")
    expect(rendered).not_to include("this is not rendered")

  end

  it "renders non-string values with their string representation" do
    flash = {
      :alert=>true
    }

    render "admin/application/flashes", :flash => flash

    expect(rendered).to include(true.to_s)
  end

  it "escapes html in values" do
    flash = {
      :alert=>"<>"
    }

    render "admin/application/flashes", :flash => flash

    expect(rendered).to include("&lt;&gt;")
  end

  it "strips scripts from values" do
    flash = {
      :alert=>"Some text and <script>malicious javascript</script>"
    }

    render "admin/application/flashes", :flash => flash

    expect(rendered).to include("Some text and malicious javascript")
    expect(rendered).not_to include("script>")
  end
end
