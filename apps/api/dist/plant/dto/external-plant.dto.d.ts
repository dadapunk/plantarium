export declare class ExternalPlantDTO {
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
    data: Array<{
        key: string;
        value: string;
    }>;
    images: {
        thumb: string;
        title: string;
    };
    constructor(json: any);
}
