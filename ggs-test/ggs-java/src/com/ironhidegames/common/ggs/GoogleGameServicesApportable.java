package com.ironhidegames.common.ggs;

import android.util.Log;
import android.os.Bundle;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.drive.Drive;
import com.google.android.gms.games.Games;
import com.google.android.gms.games.GamesStatusCodes;
import com.google.android.gms.games.snapshot.Snapshot;
import com.google.android.gms.games.snapshot.SnapshotMetadata;
import com.google.android.gms.games.snapshot.SnapshotMetadataChange;
import com.google.android.gms.games.snapshot.Snapshots;
import com.google.android.gms.plus.Plus;

import com.apportable.activity.VerdeActivity;

public class GoogleGameServicesApportable implements GoogleApiClient.ConnectionCallbacks, GoogleApiClient.OnConnectionFailedListener
{
    private GoogleApiClient mGoogleApiClient;
    
    public GoogleGameServicesApportable()
    {
        
    }
    
    public void printText(String text)
    {
        Log.d("GoogleGameServicesApportable", text);
    }
    
    public void initApi()
    {
        VerdeActivity verdeActivity = VerdeActivity.getActivity();
        
        Log.d("GoogleGameServicesApportable", "initApi");
        
        mGoogleApiClient = new GoogleApiClient.Builder(verdeActivity)
            .addConnectionCallbacks(this)
            .addOnConnectionFailedListener(this)
            .addApi(Plus.API).addScope(Plus.SCOPE_PLUS_LOGIN)
            .addApi(Games.API).addScope(Games.SCOPE_GAMES)
            .addApi(Drive.API).addScope(Drive.SCOPE_APPFOLDER)
            .build();
    }
    
    public boolean isConnected() {
        return mGoogleApiClient != null && mGoogleApiClient.isConnected();
    }
    
    public void connect()
    {
        if (this.isConnected()) {
            Log.d("GoogleGameServicesApportable", "it is already connected");
        } else {
            Log.d("GoogleGameServicesApportable", "connecting");
            mGoogleApiClient.connect();
        }
    }
    
    public void disconnect() {
        if (!this.isConnected()) {
            Log.d("GoogleGameServicesApportable", "can't disconnect since it is not connected");
        } else {
            Log.d("GoogleGameServicesApportable", "disconnecting");
            Games.signOut(mGoogleApiClient);
            mGoogleApiClient.disconnect();
        }
    }
    
    @Override
    public void onConnected (Bundle connectionHint)
    {
        Log.d("GoogleGameServicesApportable", "onConnected");
    }
    
    @Override
    public void onConnectionSuspended (int cause)
    {
        Log.d("GoogleGameServicesApportable", "onConnectionSuspended: " + cause);
    }
    
    @Override
    public void onConnectionFailed (ConnectionResult result)
    {
        int errorCode = result.getErrorCode();
        
        Log.d("GoogleGameServicesApportable", "onConnectionFailed: " + errorCode + ", " + result.isSuccess());
        if (errorCode == ConnectionResult.SIGN_IN_REQUIRED || errorCode == ConnectionResult.RESOLUTION_REQUIRED) {
            try {
                result.startResolutionForResult(VerdeActivity.getActivity(), errorCode);
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        }
    }
    
}