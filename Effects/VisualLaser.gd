extends Node3D

var fire := false
var hit := false
var start : Vector3
var end : Vector3
var viewer : Vector3
var width : float = .5

var progress := 0.0

@onready var ig: ImmediateMesh = $LaserGeometry.mesh

const PROGRESS_SPEED = 1.0

func _physics_process(delta):
	progress =  clamp(progress + PROGRESS_SPEED * delta * (1 if fire else -1), 0.0, 1.0)
	var laser_visible = progress == 0.0
	$LaserGeometry.visible = laser_visible
	$LaserOrigin.visible = laser_visible
	if laser_visible:
		$LaserOrigin.material_override.set("shader_parameter/progress", progress)
		$LaserGeometry.material_override.set("shader_parameter/progress", progress)

func refresh(_fire: bool,_start: Vector3, _end: Vector3, _viewer: Vector3, _hit: bool):
	fire = _fire
	start = _start
	end = _end
	viewer = _viewer
	draw_geo()
	$LaserOrigin.global_position = start
	$LaserParticles.global_position = start
	$LaserParticles.emitting = fire
	$LaserHit.visible = hit and fire
	$LaserHit.global_position = end

func draw_geo():
	
	var laser_dir := start.direction_to(end)
	var viewer_dir := start.direction_to(viewer)
	var billboard_dir := laser_dir.cross(viewer_dir)
	
	ig.clear_surfaces()
	ig.surface_begin(Mesh.PRIMITIVE_TRIANGLES)
	
	ig.surface_set_uv(Vector2(0,0))
	ig.surface_add_vertex(to_local(start - billboard_dir * width))
	ig.surface_set_uv(Vector2(0,1))
	ig.surface_add_vertex(to_local(start + billboard_dir * width))
	ig.surface_set_uv(Vector2(1,1))
	ig.surface_add_vertex(to_local(end + billboard_dir * width))
	
	ig.surface_set_uv(Vector2(1,0))
	ig.surface_add_vertex(to_local(end - billboard_dir * width))
	ig.surface_set_uv(Vector2(0,0))
	ig.surface_add_vertex(to_local(start - billboard_dir * width))
	ig.surface_set_uv(Vector2(1,1))
	ig.surface_add_vertex(to_local(end + billboard_dir * width))
	
	ig.surface_end()
