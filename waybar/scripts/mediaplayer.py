#!/usr/bin/env python3
import sys
import json
import subprocess
import argparse

def get_player_status(player=None):
    """Get the current media player status using playerctl"""
    try:
        # Get list of players
        players_output = subprocess.check_output(
            ['playerctl', '-l'],
            stderr=subprocess.DEVNULL
        ).decode('utf-8').strip()
        
        if not players_output:
            return None
            
        players = players_output.split('\n')
        
        # Filter by specific player if requested
        if player:
            players = [p for p in players if player.lower() in p.lower()]
            if not players:
                return None
        
        # Use the first available player
        selected_player = players[0]
        
        # Get player status
        status = subprocess.check_output(
            ['playerctl', '-p', selected_player, 'status'],
            stderr=subprocess.DEVNULL
        ).decode('utf-8').strip()
        
        if status not in ['Playing', 'Paused']:
            return None
        
        # Get metadata
        artist = subprocess.check_output(
            ['playerctl', '-p', selected_player, 'metadata', 'artist'],
            stderr=subprocess.DEVNULL
        ).decode('utf-8').strip()
        
        title = subprocess.check_output(
            ['playerctl', '-p', selected_player, 'metadata', 'title'],
            stderr=subprocess.DEVNULL
        ).decode('utf-8').strip()
        
        # Determine player type for icon
        player_name = selected_player.split('.')[0] if '.' in selected_player else selected_player
        
        return {
            'text': f'{artist} - {title}' if artist and title else title,
            'tooltip': f'{artist}\n{title}' if artist and title else title,
            'alt': player_name,
            'class': status.lower()
        }
        
    except subprocess.CalledProcessError:
        return None
    except FileNotFoundError:
        print(json.dumps({'text': '', 'tooltip': 'playerctl not installed'}))
        sys.exit(1)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--player', default=None, help='Filter by player name (e.g., spotify, firefox)')
    args = parser.parse_args()
    
    status = get_player_status(args.player)
    
    if status:
        print(json.dumps(status))
    else:
        # No player or not playing
        print(json.dumps({'text': '', 'tooltip': 'No media playing'}))

if __name__ == '__main__':
    main()
