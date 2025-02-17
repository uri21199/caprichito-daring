from werkzeug.security import check_password_hash

hashed_password = "pbkdf2:sha256:1000000$RaMtVMoh2ACi2whk$f48e673bc0a693cf57453719b28c392790de7b7bd925d00cbdca717c8cd104ed"

# Prueba con la contraseña que crees que puede haber sido usada
password_to_test = "tienda1"

# Verifica si coincide
if check_password_hash(hashed_password, password_to_test):
    print("✅ La contraseña es correcta")
else:
    print("❌ La contraseña es incorrecta")
