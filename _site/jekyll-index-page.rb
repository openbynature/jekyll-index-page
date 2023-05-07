# jekyll-index-page
require "jekyll"
require "sass"

module Jekyll

  class IndexPage < Page
    def initialize(site, base, dir, name)
      @site = site
      @base = base
      @dir = dir
      @name = name
      self.process(@name)
      self.data ||= {}
    end
  end

  class CustomCollection < Collection
      attr_accessor :order
      def initialize(site, label)
          @site = site
          @label = label
          @docs = []
          @metadata = {}
          @order = 666
      end
  end

  class IndexPageGenerator < Generator
    safe true
    priority :highest

    def generate(site)
      data = site.config['blueantcorp']['structure']
      if data
          data.each do |data|
              name = 'index.html'
              title = data['title']
              category  = data['category']  || title
              permalink = data['permalink'] || "/#{category}/"
              published = data['published'] || false
              if title && category && permalink && published
                  page =  IndexPage.new(site, site.source, permalink, name)
                  page.data['layout'] = data['layout'] || 'page_index'
                  page.data['title'] = title
                  page.data['description'] = data['description'] || ''
                  page.data['category'] = category
                  page.data['permalink'] = permalink
                  page.data['published'] = published
                  page.data['order'] = data['order'] || 666
                  site.pages << page

                  # if published
                  #   collection = CustomCollection.new(site, category)
                  #   collection.order = data['order'] || 666
                  #   collection.metadata['output'] = true
                  #   collection.metadata['permalink'] = permalink + ':title'
                  #   site.collections[category] = collection
                  # end
              end
          end
      end
    end
  end
end