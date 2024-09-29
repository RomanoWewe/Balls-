extends BossState
class_name BossDefeatState

func enter():
	%BodyAnimator.play("defeat")
	for boulder in %Boulders.get_children():
		boulder.get_node("AnimationPlayer").play("dissapear")
	%BossIntro.play(1.5)
	shake()
	silence_music()
	await get_tree().create_timer(1.6).timeout
	shrink()
	await get_tree().create_timer(0.5).timeout
	%DefeatParticles.emitting=true
	%BossDeath.play()
	await get_tree().create_timer(3).timeout
	%CurrentLevel.get_parent().complete_level()

func shrink():
	var body=%BodyAnimator.get_parent()
	var t=0
	while t<.5:
		t+=0.03
		body.scale=lerp(body.scale,Vector3.ZERO,0.15)
		await get_tree().create_timer(0.03).timeout
	body.queue_free()
	

func shake():
	var body=%BodyAnimator.get_parent()
	var starting_pos=body.position
	var t=0
	while t<2:
		t+=0.03
		body.position=lerp(body.position,get_random_position(starting_pos),0.2)
		await get_tree().create_timer(0.03).timeout

func get_random_position(start_pos:Vector3):
	var rng= RandomNumberGenerator.new()
	var x= start_pos.x+rng.randf_range(-1,1)
	var y= start_pos.y+rng.randf_range(-1,1)
	var z= start_pos.z+rng.randf_range(-1,1)
	return Vector3(x,y,z)

func silence_music():
	var music = %Music as AudioStreamPlayer
	var t=0
	while t<1:
		t+=0.03
		music.volume_db= lerp(-30,-100,t)
		await get_tree().create_timer(0.03).timeout
	music.playing=false
