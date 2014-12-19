package com.ironhidegames.common.ggs;

import android.util.Log;
import android.os.Bundle;
import android.content.Intent;
import android.app.Activity;

import android.app.ProgressDialog;
import android.graphics.Bitmap;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.RatingBar;
import android.widget.RatingBar.OnRatingBarChangeListener;
import android.widget.TextView;
import android.widget.Toast;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.drive.Drive;
import com.google.android.gms.games.Games;
import com.google.android.gms.games.GamesStatusCodes;

import com.google.android.gms.games.snapshot.*;

import com.google.android.gms.plus.Plus;

import com.apportable.activity.VerdeActivity;

public class GoogleGameServicesSnapshot
{
    private final String TAG = "GoogleGameServicesSnapshot";
    
    private Snapshot snapshot = null;
    private SnapshotContents snapshotContents = null;

    private boolean loaded;
    private boolean opening;
    
    private native void openCallback(int status);
    
    private GoogleGameServicesApportable googleGameServicesApportable;
    
    public void setGoogleGameServicesApportable(GoogleGameServicesApportable googleGameServicesApportable)
    {
        this.googleGameServicesApportable = googleGameServicesApportable;
    }
    
    public GoogleGameServicesSnapshot()
    {
        
    }
    
    public void open(final String name) {
        
        this.loaded = false;
        this.opening = true;
        
        AsyncTask<Void, Void, Integer> task = new AsyncTask<Void, Void, Integer>() {
            @Override
            protected Integer doInBackground(Void... params) {
                Snapshots.OpenSnapshotResult result = Games.Snapshots.open(googleGameServicesApportable.mGoogleApiClient, name, true).await();
                int status = result.getStatus().getStatusCode();
                
                Log.d(TAG, "snapshot loaded with result: " + status);
                
                if (status == GamesStatusCodes.STATUS_OK) {
                    Log.d(TAG, "snapshot loaded status ok");
                    GoogleGameServicesSnapshot.this.snapshot = result.getSnapshot();
                    GoogleGameServicesSnapshot.this.snapshotContents = snapshot.getSnapshotContents();
                } else if (status == GamesStatusCodes.STATUS_SNAPSHOT_CONFLICT) {
                    Log.d(TAG, "snapshot conflict");
                    // process...
                } else {
                    Log.d(TAG, "snapshot error");
                }
             
                GoogleGameServicesSnapshot.this.loaded = true;
                GoogleGameServicesSnapshot.this.opening = false;
                
                return status;
            }
            
            @Override
            protected void onPostExecute(Integer status) {
                // callback
                Log.d(TAG, "on post execute: " + status);
                openCallback(status);
            }
        };
        
        task.execute();

    }
    
    public boolean isOpening() {
        return this.opening;
    }
    
    public boolean isLoaded() {
        return this.loaded;
    }
    
    public boolean isClosed() {
        if (this.snapshotContents == null)
            return true;
        return this.snapshotContents.isClosed();
    }
    
    public byte[] getContentsBytes() {
        if (!this.isLoaded())
            return null;
        try {
            return this.snapshotContents.readFully();
        } catch (Exception e) {
            Log.d(TAG, "failed to load data from snapshot contents: " + e.getMessage());
            return null;
        }
    }
    
    public void modifyBytes(int dstOffset, byte[] bytes, int srcOffset, int count) {
        this.snapshotContents.modifyBytes(dstOffset, bytes, srcOffset, count);
    }
    
    public void writeBytes(byte[] bytes) {
        this.snapshotContents.writeBytes(bytes);
    }
    
}