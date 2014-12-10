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
    private final String TAG = "GoogleGameServicesApportable";
    
    public final static int CLIENT_NONE = 0x00;
    public final static int CLIENT_GAMES = 0x01;
    public final static int CLIENT_PLUS = 0x02;
    public final static int CLIENT_SNAPSHOT = 0x04;
    
    public final static int CLIENT_ALL = CLIENT_GAMES | CLIENT_PLUS | CLIENT_SNAPSHOT;
    
    private GoogleApiClient mGoogleApiClient;
    
    public GoogleGameServicesApportable()
    {
        
    }
    
    public void initGoogleApiClient(int clients)
    {
        VerdeActivity activity = VerdeActivity.getActivity();
        
        Log.d(TAG, "initApi");
        
        GoogleApiClient.Builder builder = new GoogleApiClient.Builder(activity, this, this);
        
        if ((clients & CLIENT_GAMES) != 0) {
            builder.addApi(Games.API);
            builder.addScope(Games.SCOPE_GAMES);
        }

        if ((clients & CLIENT_PLUS) != 0) {
            builder.addApi(Plus.API);
            builder.addScope(Plus.SCOPE_PLUS_LOGIN);
        }

        if ((clients & CLIENT_SNAPSHOT) != 0) {
            builder.addScope(Drive.SCOPE_APPFOLDER);
            builder.addApi(Drive.API);
        }
        
        mGoogleApiClient = builder.build();
    }
    
    public boolean isConnected() {
        return mGoogleApiClient != null && mGoogleApiClient.isConnected();
    }
    
    public void connect()
    {
        if (this.isConnected()) {
            Log.d(TAG, "it is already connected");
        } else {
            Log.d(TAG, "connecting");
            mGoogleApiClient.connect();
        }
    }
    
    public void disconnect() {
        if (!this.isConnected()) {
            Log.d(TAG, "can't disconnect since it is not connected");
        } else {
            Log.d(TAG, "disconnecting");
            Games.signOut(mGoogleApiClient);
            mGoogleApiClient.disconnect();
        }
    }
    
    @Override
    public void onConnected (Bundle connectionHint)
    {
        Log.d(TAG, "onConnected");
    }
    
    @Override
    public void onConnectionSuspended (int cause)
    {
        Log.d(TAG, "onConnectionSuspended: " + cause + ", trying to reconnect");
        mGoogleApiClient.connect();
    }
    
    @Override
    public void onConnectionFailed (ConnectionResult result)
    {
        int errorCode = result.getErrorCode();
        
        Log.d(TAG, "onConnectionFailed: " + errorCode + ", " + result.isSuccess());
        if (errorCode == ConnectionResult.SIGN_IN_REQUIRED || errorCode == ConnectionResult.RESOLUTION_REQUIRED) {
            try {
                result.startResolutionForResult(VerdeActivity.getActivity(), errorCode);
            } catch (Exception e) {
                throw new RuntimeException(e);
            }
        }
    }
    
}