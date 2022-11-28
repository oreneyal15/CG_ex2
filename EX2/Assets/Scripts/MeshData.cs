using System;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using UnityEngine;


public class MeshData
{
    public List<Vector3> vertices; // The vertices of the mesh 
    public List<int> triangles; // Indices of vertices that make up the mesh faces
    public Vector3[] normals; // The normals of the mesh, one per vertex

    // Class initializer
    public MeshData()
    {
        vertices = new List<Vector3>();
        triangles = new List<int>();
    }

    // Returns a Unity Mesh of this MeshData that can be rendered
    public Mesh ToUnityMesh()
    {
        Mesh mesh = new Mesh
        {
            vertices = vertices.ToArray(),
            triangles = triangles.ToArray(),
            normals = normals
        };

        return mesh;
    }

    // Calculates surface normals for each vertex, according to face orientation
    public void CalculateNormals()
    {
        var normalsList = new List<Vector3>();
        
        for (int i = 0; i < vertices.Count; i++)
        {
            List<Vector3> vNormals = new List<Vector3>();
            for (int j = 0; j < triangles.Count; j = j + 3)
            {
                if (i == triangles[j] || i == triangles[j + 1] || i == triangles[j + 2])
                {
                    var normal = Vector3.Cross(vertices[triangles[j]] - vertices[triangles[j+2]], vertices[triangles[j+1]] - vertices[triangles[j+2]]);
                    vNormals.Add(normal);
                }
            }

            var currNormal = Vector3.zero;
            foreach (var normal in vNormals)
            {
                currNormal += normal;
            }

            normalsList.Add(currNormal.normalized);
        }

        normals = normalsList.ToArray();
    }

    // Edits mesh such that each face has a unique set of 3 vertices
    public void MakeFlatShaded()
    {
        var numVertices = vertices.Count;
        for (int i = 0; i < numVertices; i++)
        {
            Boolean fistAppearance = true;
            for (int j = 0; j < triangles.Count; j++)
            {
                if (triangles[j] == i)
                {
                    if (!fistAppearance)
                    {
                        vertices.Add(vertices[i]);
                        triangles[j] = vertices.Count - 1;
                    }
                    else
                    {
                        fistAppearance = false;
                    }
                }
                
            }
        }
        
    }
}