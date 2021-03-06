package com.genome2d.textures;
import com.genome2d.geom.GRectangle;
import com.genome2d.proto.IGPrototypable;

@:access(com.genome2d.textures.GTextureManager)
class GTextureAtlas implements IGPrototypable {

    private var g2d_id:String;
    /**
	 * 	Id
	 */
    @prototype
    #if swc @:extern #end
    public var id(get,set):String;
        #if swc @:getter(id) #end
    inline private function get_id():String {
        return g2d_id;
    }
    #if swc @:setter(id) #end
    inline private function set_id(p_value:String):String {
        if (g2d_id != p_value) {
            GTextureManager.removeTextureAtlas(this);
            g2d_id = p_value;
            if (g2d_texture == null) g2d_texture = GTextureManager.getTexture(g2d_id);
            GTextureManager.addTextureAtlas(this);
        }
        return g2d_id;
    }

    private var g2d_texture:GTexture;
    public function getTexture():GTexture {
        return g2d_texture;
    }

    private var g2d_subTextures:Array<GTexture>;

    public function new() {
        g2d_subTextures = new Array<GTexture>();
    }

    public function addSubTexture(p_texture:GTexture):Void {
        g2d_subTextures.push(p_texture);
    }

    public function getSubTexture(p_id:String):GTexture {
        for (texture in g2d_subTextures) {
            if (texture.id == p_id) return texture;
        }

        return null;
    }

    public function findTexture(p_regExp:EReg):GTexture {
        for (texture in g2d_subTextures) {
            if (p_regExp.match(texture.id)) {
                return texture;
            }
        }

        return null;
    }

    public function addSubTexturesFromXml(p_xml:Xml, p_prefixParentId:Bool = true):Void {
        var root = p_xml.firstElement();
        var it:Iterator<Xml> = root.elements();

        while(it.hasNext()) {
            var node:Xml = it.next();

            var region:GRectangle = new GRectangle(Std.parseInt(node.get("x")), Std.parseInt(node.get("y")), Std.parseInt(node.get("width")), Std.parseInt(node.get("height")));
            var frame:GRectangle = null;

            if (node.get("frameX") != null && node.get("frameWidth") != null && node.get("frameY") != null && node.get("frameHeight") != null) {
                frame = new GRectangle(Std.parseInt(node.get("frameX")), Std.parseInt(node.get("frameY")), Std.parseInt(node.get("frameWidth")), Std.parseInt(node.get("frameHeight")));
            }
            addSubTexture(GTextureManager.createSubTexture(node.get("name"), g2d_texture, region, frame, p_prefixParentId));
        }
    }

    /*
	 *	Get a reference value
	 */
    public function toReference():String {
        return "@"+g2d_id;
    }

    /*
	 * 	Get an instance from reference
	 */
    static public function fromReference(p_reference:String) {
        return GTextureManager.getTextureAtlas(p_reference.substr(1));
    }
}
