<?php

namespace App\Http\Controllers\Backend;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class ApiPendidikanController extends Controller
{
    private $storagePath = 'pendidikan.json';

    private function getData()
    {
        if (!Storage::exists($this->storagePath)) {
            Storage::put($this->storagePath, json_encode([]));
        }
        return json_decode(Storage::get($this->storagePath), true);
    }

    private function saveData($data)
    {
        Storage::put($this->storagePath, json_encode($data, JSON_PRETTY_PRINT));
    }

    public function getAll()
    {
        return response()->json($this->getData())
            ->header('Access-Control-Allow-Origin', '*');
    }

    public function getPen($id)
    {
        $data = $this->getData();
        $item = collect($data)->firstWhere('id', (int)$id);

        return $item
            ? response()->json($item)
            : response()->json(['error' => 'Data tidak ditemukan'], 404);
    }

    public function createPen(Request $request)
    {
        try {
            $validated = $request->validate([
                'nama' => 'required|string',
                'tingkatan' => 'required|string',
                'tahun_masuk' => 'required|numeric',
                'tahun_keluar' => 'required|numeric'
            ]);

            $data = $this->getData();
            $newId = empty($data) ? 1 : max(array_column($data, 'id')) + 1;

            $newItem = [
                'id' => $newId,
                'nama' => $validated['nama'],
                'tingkatan' => $validated['tingkatan'],
                'tahun_masuk' => $validated['tahun_masuk'],
                'tahun_keluar' => $validated['tahun_keluar']
            ];

            $data[] = $newItem;
            $this->saveData($data);

            return response()->json($newItem, 201)
                ->header('Access-Control-Allow-Origin', '*');
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Validasi gagal',
                'message' => $e->getMessage()
            ], 400);
        }
    }

    public function updatePen(Request $request, $id)
    {
        try {
            $validated = $request->validate([
                'nama' => 'required|string',
                'tingkatan' => 'required|string',
                'tahun_masuk' => 'required|numeric',
                'tahun_keluar' => 'required|numeric'
            ]);

            $data = $this->getData();
            $index = collect($data)->search(function ($item) use ($id) {
                return $item['id'] == (int)$id;
            });

            if ($index === false) {
                return response()->json(['error' => 'Data tidak ditemukan'], 404);
            }

            $data[$index] = array_merge($data[$index], $validated);
            $this->saveData($data);

            return response()->json($data[$index])
                ->header('Access-Control-Allow-Origin', '*');
        } catch (\Exception $e) {
            return response()->json([
                'error' => 'Validasi gagal',
                'message' => $e->getMessage()
            ], 400);
        }
    }

    public function deletePen($id)
    {
        $data = $this->getData();
        $countBefore = count($data);

        $data = array_filter($data, function ($item) use ($id) {
            return $item['id'] != (int)$id;
        });

        if (count($data) < $countBefore) {
            $this->saveData(array_values($data));
            return response()->json(['message' => 'Data berhasil dihapus'])
                ->header('Access-Control-Allow-Origin', '*');
        }

        return response()->json(['error' => 'Data tidak ditemukan'], 404);
    }
}