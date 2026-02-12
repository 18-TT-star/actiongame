extends CharacterBody2D

const SPEED := 1000.0
const JUMP_VELOCITY := -1000.0
const GRAVITY := 1000.0
const FALL_GRAVITY := 2000.0  # 落下時の重力（上昇時より強い）


func _physics_process(delta: float) -> void:
	# 重力
	if not is_on_floor():
		# 落下中は重力を強くする
		if velocity.y > 0:
			velocity.y += FALL_GRAVITY * delta
		else:
			velocity.y += GRAVITY * delta
	else:
		# 床にいるときに落下速度をリセット（安定）
		if velocity.y > 0:
			velocity.y = 0

	# 左右移動（ui_left / ui_right はデフォルトで設定済み）
	var dir := Input.get_axis("ui_left", "ui_right")
	velocity.x = dir * SPEED

	# ジャンプ（スペースキーのみ）
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	move_and_slide()
