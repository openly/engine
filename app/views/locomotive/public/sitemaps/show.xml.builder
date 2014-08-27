xml.instruct!
xml.urlset "xmlns" => "http://www.sitemaps.org/schemas/sitemap/0.9" do


@pages.each do |page|
  if page.index?
    xml.url do
      priorityCheck = page.attributes['xml_priority'] != nil && page.attributes['xml_priority']['en'] != ""
      xml.loc public_page_url(page)
      xml.lastmod page.updated_at.to_date.to_s('%Y-%m-%d')
      xml.changefreq page.attributes['change_frequency']
      xml.priority priorityCheck  ? page.attributes['xml_priority']['en']:1.0
    end
  end
end


  @pages.each do |page|
    if not page.index_or_not_found?
      if page.templatized?
        page.fetch_target_entries(_visible: true).each do |c|
          xml.url do
            priorityCheckPage = c.attributes['xml_priority'] != nil && c.attributes['xml_priority']['en'] != ""
            xml.loc public_page_url(page, { content: c })
            xml.lastmod c.updated_at.to_date.to_s('%Y-%m-%d')
            xml.changefreq c.attributes['change_frequency']
            xml.priority priorityCheckPage ? c.attributes['xml_priority']['en']:0.9
          end
        end
      else
        xml.url do
          priorityCheckBlogPage = page.attributes['xml_priority'] != nil && page.attributes['xml_priority']['en'] != ""
          xml.loc public_page_url(page)
          xml.lastmod page.updated_at.to_date.to_s('%Y-%m-%d')
          xml.changefreq page.attributes['change_frequency']
          xml.priority priorityCheckBlogPage ? page.attributes['xml_priority']['en']:0.9
        end
      end
    end
  end
end
