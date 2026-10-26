extends Node3D

var score := 0
var health := 100
var enemies: Array = []
var player: CharacterBody3D
var status_label: Label

func _ready():
    make_world()
    make_player()
    make_zombies()
    make_hud()

func make_world():
    var world_environment = WorldEnvironment.new()
    var environment = Environment.new()
    environment.background_mode = Environment.BG_SKY
    environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
    environment.ambient_light_color = Color(0.35, 0.38, 0.32)
    environment.ambient_light_energy = 0.7
    world_environment.environment = environment
    add_child(world_environment)

    var sun = DirectionalLight3D.new()
    sun.rotation_degrees = Vector3(-55, -30, 0)
    sun.light_energy = 0.8
    add_child(sun)

    var ground = StaticBody3D.new()
    ground.name = "Ground"
    add_child(ground)

    var ground_mesh = MeshInstance3D.new()
    var plane = BoxMesh.new()
    plane.size = Vector3(100, 1, 100)
    ground_mesh.mesh = plane
    var ground_material = StandardMaterial3D.new()
    ground_material.albedo_color = Color(0.18, 0.20, 0.16)
    ground_mesh.material_override = ground_material
    ground.add_child(ground_mesh)

    var ground_collision = CollisionShape3D.new()
    var ground_shape = BoxShape3D.new()
    ground_shape.size = Vector3(100, 1, 100)
    ground_collision.shape = ground_shape
    ground.add_child(ground_collision)

    for i in range(12):
        var building = MeshInstance3D.new()
        var box = BoxMesh.new()
        box.size = Vector3(randf_range(3, 7), randf_range(4, 12), randf_range(3, 7))
        building.mesh = box
        var material = StandardMaterial3D.new()
        material.albedo_color = Color(0.22, 0.23, 0.21)
        building.material_override = material
        building.position = Vector3(randf_range(-35, 35), box.size.y / 2, randf_range(-35, 35))
        add_child(building)

func make_player():
    player = CharacterBody3D.new()
    player.name = "Player"
    player.position = Vector3(0, 1, 8)
    add_child(player)

    var body_shape = CollisionShape3D.new()
    var capsule = CapsuleShape3D.new()
    capsule.height = 1.8
    capsule.radius = 0.35
    body_shape.shape = capsule
    player.add_child(body_shape)

    var camera = Camera3D.new()
    camera.name = "Camera3D"
    camera.position.y = 0.65
    camera.current = true
    player.add_child(camera)

    player.set_script(load("res://scripts/player.gd"))

func make_zombies():
    for i in range(8):
        var zombie = CharacterBody3D.new()
        zombie.name = "Zombie"
        zombie.position = Vector3(randf_range(-18, 18), 1, randf_range(-20, -5))
        add_child(zombie)

        var mesh_instance = MeshInstance3D.new()
        var capsule_mesh = CapsuleMesh.new()
        capsule_mesh.height = 1.8
        capsule_mesh.radius = 0.4
        mesh_instance.mesh = capsule_mesh
        var skin = StandardMaterial3D.new()
        skin.albedo_color = Color(0.25, 0.48, 0.24)
        mesh_instance.material_override = skin
        zombie.add_child(mesh_instance)

        var collision = CollisionShape3D.new()
        var shape = CapsuleShape3D.new()
        shape.height = 1.8
        shape.radius = 0.4
        collision.shape = shape
        zombie.add_child(collision)

        zombie.set_script(load("res://scripts/zombie.gd"))
        zombie.target = player
        enemies.append(zombie)

func make_hud():
    var layer = CanvasLayer.new()
    add_child(layer)

    status_label = Label.new()
    status_label.position = Vector2(20, 20)
    status_label.add_theme_font_size_override("font_size", 24)
    status_label.add_theme_color_override("font_color", Color(0.4, 1, 0.4))
    status_label.text = "DEAD ZONE: SURVIVAL  |  HP: 100  |  ZOMBIES: 8"
    layer.add_child(status_label)

    var crosshair = Label.new()
    crosshair.text = "+"
    crosshair.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
    crosshair.add_theme_font_size_override("font_size", 30)
    crosshair.add_theme_color_override("font_color", Color.WHITE)
    layer.add_child(crosshair)

func _process(_delta):
    if is_instance_valid(status_label):
        status_label.text = "DEAD ZONE: SURVIVAL  |  HP: %d  |  ZOMBIES: %d" % [health, enemies.size()]
