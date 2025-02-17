
    <div class="container-fluid py-5">
        <div class="container">
            <form action="/profile/update" method="POST">
                <!-- Nombre de la tienda -->
                <div class="form-group">
                  <label for="store_name">Nombre de tienda</label>
                  <input type="text" class="form-control" id="store_name" name="store_name" value="{{ user.store_name }}" required>
                </div>
                <!-- Email -->
                <div class="form-group">
                  <label for="mail">Correo Electrónico</label>
                  <input type="email" class="form-control" id="mail" name="mail" value="{{ user.mail }}" required>
                </div>
                <!-- Contraseña -->
                <div class="form-group">
                  <label for="password">Contraseña</label>
                  <input type="password" class="form-control" id="password" name="password" placeholder="Ingrese nueva contraseña si desea cambiarla">
                </div>
                <!-- CUIT -->
                <div class="form-group">
                  <label for="cuit">CUIT</label>
                  <input type="text" class="form-control" id="cuit" name="cuit" value="{{ user.cuit }}" required>
                </div>
                <!-- Provincia -->
                <div class="form-group">
                  <label for="province">Provincia</label>
                  <input type="text" class="form-control" id="province" name="province" value="{{ user.province }}">
                </div>
                <!-- Ciudad -->
                <div class="form-group">
                  <label for="city">Ciudad</label>
                  <input type="text" class="form-control" id="city" name="city" value="{{ user.city }}">
                </div>
                <!-- Teléfono -->
                <div class="form-group">
                  <label for="phone">Teléfono</label>
                  <input type="text" class="form-control" id="phone" name="phone" value="{{ user.phone }}">
                </div>
                <!-- Dirección -->
                <div class="form-group">
                  <label for="address">Dirección</label>
                  <input type="text" class="form-control" id="address" name="address" value="{{ user.address }}">
                </div>
                <!-- Website -->
                <div class="form-group">
                  <label for="website">Website</label>
                  <input type="text" class="form-control" id="website" name="website" value="{{ user.website }}">
                </div>
                <!-- Botón de Enviar -->
                <button type="submit" class="btn btn-primary btn-block">Actualizar</button>
              </form>
              
        </div>
    </div>