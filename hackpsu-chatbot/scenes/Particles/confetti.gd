extends Node2D

class_name ParticleConfetti

@onready var conffeti_particles: Array[CPUParticles2D] = [$Green, $Blue, $"Real Purp", $"Real Red"]

func play():
	for particle in conffeti_particles:
		particle.emitting = true
