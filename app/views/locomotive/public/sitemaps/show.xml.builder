xml.instruct!
xml.urlset "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do

  xml.url do
    xml.loc current_site_public_url
    xml.lastmod current_site.updated_at.to_date.to_s('%Y-%m-%d')
    xml.changefreq current_site.attributes['change_frequency']
    xml.priority current_site.attributes['xml_priority'] != nil ? current_site.attributes['xml_priority']['en']:1.0
  end


  @pages.each do |page|
    if not page.index_or_not_found?
      if page.templatized?
        page.fetch_target_entries(_visible: true).each do |c|
          xml.url do
            xml.loc public_page_url(page, { content: c })
            xml.lastmod c.updated_at.to_date.to_s('%Y-%m-%d')
            xml.changefreq c.attributes['change_frequency']
            xml.priority c.attributes['xml_priority'] != nil ? c.attributes['xml_priority']['en']:0.9
          end
        end
      else
        xml.url do
          xml.loc public_page_url(page)
          xml.lastmod page.updated_at.to_date.to_s('%Y-%m-%d')
          xml.changefreq page.attributes['change_frequency']
          xml.priority page.attributes['xml_priority'] != nil ? page.attributes['xml_priority']['en']:0.9
        end
      end
    end
  end
end
