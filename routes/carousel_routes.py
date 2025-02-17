from flask import Blueprint, jsonify
from models import Carousel

carousel_bp = Blueprint('carousel_bp', __name__)

@carousel_bp.route('/api/carousel', methods=['GET'])
def get_carousel():
    # Consultar las imágenes activas del carrusel
    slides = Carousel.query.filter_by(active=True).all()

    # Convertir a formato JSON
    carousel_data = [
        {
            "id": slide.id,
            "image_url": slide.image_url,
            "title": slide.title,
            "subtitle": slide.subtitle
        }
        for slide in slides
    ]
    return jsonify({"carousel": carousel_data})
