-- Tabla de Usuarios
CREATE TABLE usuarios (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    correo VARCHAR(100),
    contrasena VARCHAR(100),
    tipo ENUM('administrador', 'cliente')
);

-- Tabla de Categorías
CREATE TABLE categorias (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100)
);

-- Tabla de Productos
CREATE TABLE productos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    descripcion TEXT,
    precio DECIMAL(10,2),
    stock INT,
    categoria_id INT,
    FOREIGN KEY (categoria_id) REFERENCES categorias(id)
);

-- Tabla de Pedidos
CREATE TABLE pedidos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id INT,
    fecha_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_pedido DECIMAL(10,2),
    estado ENUM('pendiente', 'completado', 'cancelado'),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

-- Tabla de Detalles de Pedidos
CREATE TABLE detalles_pedido (
    id INT PRIMARY KEY AUTO_INCREMENT,
    pedido_id INT,
    producto_id INT,
    cantidad INT,
    precio_unitario DECIMAL(10,2),
    total_linea DECIMAL(10,2),
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id),
    FOREIGN KEY (producto_id) REFERENCES productos(id)
);

-- Tabla de Métodos de Pago
CREATE TABLE metodos_pago (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100)
);

-- Tabla de Pagos
CREATE TABLE pagos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    pedido_id INT,
    metodo_pago_id INT,
    monto DECIMAL(10,2),
    fecha_pago TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (pedido_id) REFERENCES pedidos(id),
    FOREIGN KEY (metodo_pago_id) REFERENCES metodos_pago(id)
);

-- Tabla de Direcciones de Envío (Si aplica)
CREATE TABLE direcciones_envio (
    id INT PRIMARY KEY AUTO_INCREMENT,
    usuario_id INT,
    direccion VARCHAR(255),
    ciudad VARCHAR(100),
    estado VARCHAR(100),
    codigo_postal VARCHAR(10),
    FOREIGN KEY (usuario_id) REFERENCES usuarios(id)
);

-- Otras tablas según tus necesidades (por ejemplo, opiniones de productos, cupones, etc.)
php artisan make:model Usuario -m
php artisan make:model Categoria -m
php artisan make:model Producto -m
php artisan make:model Pedido -m
php artisan make:model DetallePedido -m
php artisan make:model MetodoPago -m
php artisan make:model Pago -m
php artisan make:model DireccionEnvio -m

<!-- Enlaza el CSS de Bootstrap -->
<link rel="stylesheet" href="{{ asset('resources/css/bootstrap.min.css') }}">

<!-- Enlaza el JS de Bootstrap (debe estar después de jQuery) -->
<script src="{{ asset('resources/js/bootstrap.min.js') }}"></script>

php artisan make:model Producto -m

public function up()
{
    Schema::create('productos', function (Blueprint $table) {
        $table->id();
        $table->string('nombre');
        $table->text('descripcion');
        $table->decimal('precio', 8, 2);
        $table->integer('stock');
        $table->timestamps();
    });
}

php artisan migrate

public function categoria()
{
    return $this->belongsTo(Categoria::class);
}

php artisan make:controller ProductoController

use App\Http\Controllers\ProductoController;

Route::get('/productos', [ProductoController::class, 'index']);

@extends('layout')

@section('content')
    <h1>Productos Disponibles</h1>
    <ul>
        @foreach ($productos as $producto)
            <li>{{ $producto->nombre }} - Precio: ${{ $producto->precio }}</li>
        @endforeach
    </ul>
@endsection

use App\Models\Producto;

public function index()
{
    $productos = Producto::all();
    return view('productos.index', ['productos' => $productos]);
}

@extends('layout')

@section('content')
    <div class="container mt-5">
        <h1>Productos Disponibles</h1>

        <div class="row">
            @foreach ($productos as $producto)
                <div class="col-md-4 mb-4">
                    <div class="card">
                        <img src="{{ $producto->imagen }}" class="card-img-top" alt="{{ $producto->nombre }}">
                        <div class="card-body">
                            <h5 class="card-title">{{ $producto->nombre }}</h5>
                            <p class="card-text">{{ $producto->descripcion }}</p>
                            <p class="card-text">Precio: ${{ $producto->precio }}</p>
                            <p class="card-text">Stock: {{ $producto->stock }}</p>
                            <a href="{{ route('productos.show', $producto->id) }}" class="btn btn-primary">Ver Detalles</a>
                        </div>
                    </div>
                </div>
            @endforeach
        </div>
    </div>
@endsection
