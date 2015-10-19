class AddStaticDealTaxonIntoCategoriesTaxonomy < ActiveRecord::Migration
  def up
    categories_taxonomy = Spree::Taxonomy.find_or_create_by(name: 'Categories')
    categories_taxon = Spree::Taxon.where(name: 'Categories', taxonomy: categories_taxonomy).first
    Spree::Taxon.find_or_create_by(name: 'StaticDeal', parent_id: categories_taxon.id, taxonomy_id: categories_taxonomy.id)
  end

  def down
    categories_taxonomy = Spree::Taxonomy.where(name: 'Categories').try(:first)
    categories_taxon = Spree::Taxon.where(name: 'Categories', taxonomy: categories_taxonomy).try(:first)
    if categories_taxonomy and categories_taxon
      Spree::Taxon.where(taxonomy_id: categories_taxonomy.id, parent_id: categories_taxon.id, name: 'StaticDeal').delete_all
    end
  end
end
