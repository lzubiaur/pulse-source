extern vec2 direction;
extern number alpha;
vec4 effect(vec4 color, Image texture, vec2 tc, vec2 _)
{
	return color * vec4(
		Texel(texture, tc - direction).r,
		Texel(texture, tc).g,
		Texel(texture, tc + direction).b,
		alpha);
}
