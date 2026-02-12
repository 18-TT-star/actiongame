extends CharacterBody2D

const SPEED := 1000.0
const JUMP_VELOCITY := -1000.0
const GRAVITY := 1000.0
const FALL_GRAVITY := 2000.0  # 落下時の重力（上昇時より強い）
const ATTACK_DURATION := 0.3  # 攻撃表示時間（秒）

var last_direction := 1  # 最後に向いていた方向（-1: 左, 1: 右）
var attack_timer := 0.0  # 攻撃表示タイマー

@onready var character_sprite := $Node2D/Sprite2D
@onready var kogeki_left := $Node2D/KogekiLeft
@onready var kogeki_right := $Node2D/KogekiRight


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
	
	# 最後の入力方向を記録
	if dir != 0:
		last_direction = int(sign(dir))

	# ジャンプ（スペースキーのみ）
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# 攻撃（Enterキー）
	if Input.is_action_just_pressed("attack") and attack_timer <= 0:
		attack_timer = ATTACK_DURATION
		if last_direction < 0:
			kogeki_left.visible = true
			kogeki_right.visible = false
		else:
			kogeki_left.visible = false
			kogeki_right.visible = true
	
	# 攻撃表示タイマー更新
	if attack_timer > 0:
		attack_timer -= delta
		if attack_timer <= 0:
			kogeki_left.visible = false
			kogeki_right.visible = false

	move_and_slide()
