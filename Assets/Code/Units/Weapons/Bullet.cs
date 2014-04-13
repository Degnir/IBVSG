using UnityEngine;
using System.Collections;
using IBVSG;

public class Bullet : MonoBehaviour 
{
	public Unit Target;
	public Unit Owner;
	public float Speed;

	private Vector3 _Direction;
	// Use this for initialization
	void Start () 
	{
		_Direction = Target.Position - transform.position;

		if(Target.Type == Type.Player)
		{
			_Direction += Vector3.up * 0.9f ;
		}

		Destroy(this.gameObject,3);
	}
	
	// Update is called once per frame
	void Update () 
	{
		transform.position += Time.deltaTime * Speed * _Direction;

		if(Target.Type == Type.Player)
		{
			transform.Rotate(1.0f, 0.0f, 1.0f);
		}

		if(Target.Model != null && (Vector3.Distance(Target.Position, transform.position) < 0.3f || 
		                            Target.Model.collider.bounds.Contains(this.transform.position)))
		{
			Target.Hit(this);
			Destroy(this.gameObject);
		}
	}
	void OnCollisionEnter(Collision collision)
	{
		Debug.Log("Hit "+collision.gameObject.name);
	}

}
