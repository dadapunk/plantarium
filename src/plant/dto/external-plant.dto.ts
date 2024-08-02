export class ExternalPlantDTO {
  id: number;
  name: string;
  slug: string;
  description: string;
  created_at: string;
  updated_at: string;
  scientific_name: string;
  parent_id: number | null;
  adopter_id: number;
  version: number;
  type: string;
  link: string;
  data: Array<{ key: string; value: string }>;
  images: { thumb: string; title: string };

  constructor(json: any) {
    this.id = json.id;
    this.name = json.name;
    this.slug = json.slug;
    this.description = json.description;
    this.created_at = json.created_at;
    this.updated_at = json.updated_at;
    this.scientific_name = json.scientific_name;
    this.parent_id = json.parent_id;
    this.adopter_id = json.adopter_id;
    this.version = json.version;
    this.type = json.type;
    this.link = json.link;
    this.data = json.data;
    this.images = json.images;
  }
}
