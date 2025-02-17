from flask import Blueprint, jsonify
from models import SiteInfo

site_info_bp = Blueprint('site_info_bp', __name__)

@site_info_bp.route('/api/site-info', methods=['GET'])
def get_site_info():
    # Consultar todos los datos de la tabla site_info
    info = SiteInfo.query.all()

    # Convertir a formato JSON
    site_info_data = {
        item.key_name: item.value for item in info
    }
    return jsonify(site_info_data)
