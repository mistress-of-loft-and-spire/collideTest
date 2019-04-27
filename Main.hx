import h3d.Vector;
import hxd.Key;

class Main extends hxd.App {

	var rnd : hxd.Rand;
	var light : h3d.scene.fwd.DirLight;
	var obj : h3d.scene.Object;
	var tex : h3d.scene.Object;

	function initInteract( i : h3d.scene.Interactive, m : h3d.scene.Mesh ) {
		var beacon = null;
		var color = m.material.color.clone();
		
		i.bestMatch = true;
		i.onOver = function(e : hxd.Event) {
			m.material.color.set(0, 1, 0);
			var s = new h3d.prim.Sphere(1, 32, 32);
			s.addNormals();
			beacon = new h3d.scene.Mesh(s, s3d);
			beacon.material.mainPass.enableLights = true;
			beacon.material.color.set(1, 0, 0);
			beacon.scale(0.01);
			beacon.x = e.relX;
			beacon.y = e.relY;
			beacon.z = e.relZ;
		};
		i.onMove = i.onCheck = function(e:hxd.Event) {
			if( beacon == null ) return;
			beacon.x = e.relX;
			beacon.y = e.relY;
			beacon.z = e.relZ;
		};
		i.onOut = function(e : hxd.Event) {
			m.material.color.load(color);
			beacon.remove();
			beacon = null;
		};
	}

	override function init() {
		light = new h3d.scene.fwd.DirLight(new h3d.Vector( 0.3, -0.4, -0.9), s3d);
		light.enableSpecular = true;
		light.color.set(0.28, 0.28, 0.28);

		s3d.lightSystem.ambientLight.set(0.74, 0.74, 0.74);


		//prim cube

		var c = new h3d.prim.Cube();
		c.addNormals();
		c.addUVs();
		var m = new h3d.scene.Mesh(c, s3d);
		m.y = 0.4;
		m.scale(0.4);
		m.material.color.setColor(0xaaaaaa);

		var interact = new h3d.scene.Interactive(m.getCollider(), s3d);
		initInteract(interact, m);


		//Sample skeleton .fbx

		var cache = new h3d.prim.ModelCache();
		obj = cache.loadModel(hxd.Res.Model);
		obj.scale(1 / 20);
		obj.rotate(0,0,Math.PI / 2);
		s3d.addChild(obj);

		obj.playAnimation(cache.loadAnimation(hxd.Res.Model)).speed = 0.1;

		for( o in obj ) {
			var m = o.toMesh();
			var i = new h3d.scene.Interactive(m.getCollider(), s3d);
			initInteract(i, m);
		}
		
		
		//My blender .fbx
		
		tex = cache.loadModel(hxd.Res.Tex_fbx);
		tex.scale(1 / 5);
		tex.rotate(0,0,Math.PI / 2);		
		s3d.addChild(tex);
		
		for( jj in tex.getMeshes() ) {
			var m = jj.toMesh();
			var ttt = new h3d.scene.Interactive(m.getCollider(), s3d);
			initInteract(ttt, m);
		}
		
		
	}
	
	
	override function update(dt:Float) {
		obj.rotate(0, 0, 0.1 * dt);
		tex.rotate(0, 0, -0.1 * dt);
		
		if(Key.isDown(Key.W)) s3d.camera.forward(1);
		if(Key.isDown(Key.S)) s3d.camera.forward(-1);
		if(Key.isDown(Key.A)) s3d.camera.pos.y += 0.1;
		if(Key.isDown(Key.D)) s3d.camera.pos.y -= 0.1;
		
	}


	static function main() {
		hxd.Res.initEmbed();
		new Main();
	}
}