// player.gdshader - 玩家角色着色器
//
// 设计目标：为玩家pixel提供受伤闪白效果的着色器
// 通过混合白色来实现受击反馈
//
// 类型：canvas_item - 专为2D画布项设计的着色器
shader_type canvas_item;

// 着色器参数 - 白色混合程度
// uniform：可以从GDScript（如hit_flash.gd）动态修改的参数
// percent：参数名称，表示白色混合的强度
// hint_range(0.0, 0.5, 0.1)：编辑器提示
//   - 最小值：0.0（无白色混合）
//   - 最大值：0.5（50%白色混合，编辑器滑动条限制）
//   - 步进值：0.1（拖动滑动条时的增量）
uniform float percent :hint_range(0.0, 0.5, 0.1);

// 这是片元着色器函数，每个像素都会执行
void fragment() {
	vec4 white_color = vec4(1.0, 1.0, 1.0, texture(TEXTURE, UV).a);
	COLOR = mix(texture(TEXTURE, UV), white_color, percent);
}
