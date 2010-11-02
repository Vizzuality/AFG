module GuidesHelper

  # Given a paginated collection, returns a string containing the index
  # of the first element, a connector, and the index of the last element
  # in the collection
  def guides_shown(paginated_guides, connector = 'to')
    left = paginated_guides.current_page*paginated_guides.per_page - paginated_guides.per_page + 1
    right = if paginated_guides.current_page == paginated_guides.total_pages
        paginated_guides.total_entries
      else
        left + paginated_guides.per_page - 1
      end
    "#{left} #{connector} #{right}"
  end

  def already_used_as_template?(guide, current_guide)
    guide && current_guide && guide.id == current_guide.parent_guide_id
  end
end
